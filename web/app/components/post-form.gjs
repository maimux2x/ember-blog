import Component from '@glimmer/component';
import { DirectUpload } from '@rails/activestorage/src/direct_upload';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';
import { runTask } from 'ember-lifeline';
import { on } from '@ember/modifier';
import autosizeModifier from 'web/modifiers/autosize';
import autosize from 'autosize';
import ENV from 'web/config/environment';
import Post from './post';

export default class PostFormComponent extends Component {
  setTextarea = modifier((textarea) => {
    this.textarea = textarea;
  });

  get tagNames() {
    return this.args.post.tagNames.join(', ');
  }

  @action
  setTagNames(e) {
    this.args.post.tagNames = e.target.value
      .split(',')
      .map((s) => s.trim())
      .filter((s) => s);
  }

  @action
  setTitle(e) {
    this.args.post.title = e.target.value;
  }

  @action
  setBody(e) {
    this.args.post.body = e.target.value;
  }

  @action
  uploadImage(e) {
    for (const file of e.target.files) {
      const upload = new DirectUpload(
        file,
        `${ENV.appURL}/rails/active_storage/direct_uploads`,
        {},
      );

      upload.create((error, blob) => {
        if (error) {
          console.error(error.message);
        } else {
          const startPos = this.textarea.selectionStart;
          const endPos = this.textarea.selectionEnd;
          const before = this.textarea.value.substring(0, startPos);
          const after = this.textarea.value.substring(endPos);
          const text = `![${blob.filename}](${ENV.appURL}/rails/active_storage/blobs/redirect/${blob.signed_id}/${blob.filename})`;

          this.args.post.body = before + text + after;

          runTask(this, () => {
            autosize.update(this.textarea);

            this.textarea.selectionStart = this.textarea.selectionEnd =
              startPos + text.length;
            this.textarea.focus();
          });
        }
      });
    }

    e.target.value = null;
  }

  <template>
    <ul class="nav nav-tabs mb-3" id="postFormTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button
          class="nav-link active"
          id="home"
          data-bs-toggle="tab"
          data-bs-target="#home-pane"
          type="button"
          role="tab"
          aria-controls="home-pane"
          aria-selected="true"
        >Form</button>
      </li>
      <li class="nav-item" role="presentation">
        <button
          class="nav-link"
          id="preview"
          data-bs-toggle="tab"
          data-bs-target="#preview-pane"
          type="button"
          role="tab"
          aria-controls="preview-pane"
          aria-selected="false"
        >Preview</button>
      </li>
    </ul>
    <div class="tab-content" id="postFormTabContent">
      <div
        class="tab-pane fade show active"
        id="home-pane"
        role="tabpanel"
        aria-labelledby="form-tab"
      >
        <form {{on "submit" @onSubmit}}>
          <div class="mb-3">
            <label for="title" class="form-label">Title</label>
            <input
              value={{@post.title}}
              id="title"
              class="form-control {{if @post.errors.title 'is-invalid'}}"
              {{on "input" this.setTitle}}
            />
            {{#each @post.errors.title as |error|}}
              <div class="invalid-feedback">
                {{error}}
              </div>
            {{/each}}
          </div>
          <div class="mb-3">
            <label for="body" class="form-label">Body</label>
            <textarea
              {{autosizeModifier}}
              {{this.setTextarea}}
              id="body"
              class="form-control {{if @post.errors.body 'is-invalid'}}"
              {{on "input" this.setBody}}
            >{{@post.body}}</textarea>
            {{#each @post.errors.body as |error|}}
              <div class="invalid-feedback">
                {{error}}
              </div>
            {{/each}}
          </div>
          <div class="mb-3">
            <label for="tags" class="form-label">Tag</label>
            <input
              value={{this.tagNames}}
              id="tag-names"
              class="form-control {{if @post.errors.tags 'is-invalid'}}"
              {{on "change" this.setTagNames}}
            />
            {{#each @post.errors.tags as |error|}}
              <div class="invalid-feedback">
                {{error}}
              </div>
            {{/each}}
          </div>

          <div class="mb-3">
            <input
              type="file"
              id="file"
              name="file"
              class="{{if @post.errors.images 'is-invalid'}}"
              multiple
              {{on "change" this.uploadImage}}
              hidden
            />
            <label for="file" class="btn btn-outline-primary">
              Choose image
            </label>
            {{#each @post.errors.images as |error|}}
              <div class="invalid-feedback">
                {{error}}
              </div>
            {{/each}}
          </div>
          <button
            type="submit"
            class="btn btn-primary mb-3"
          >{{@submitLabel}}</button>
        </form>
      </div>
      <div
        class="tab-pane fade"
        id="preview-pane"
        role="tabpanel"
        aria-labelledby="preview-tab"
      >
        <Post @post={{@post}} />
      </div>
    </div>
  </template>
}
