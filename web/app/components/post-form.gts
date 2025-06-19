import Component from '@glimmer/component';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import { get } from '@ember/helper';

import autosize from 'autosize';
import { DirectUpload } from '@rails/activestorage';
import { runTask } from 'ember-lifeline';

import ENV from 'web/config/environment';
import Post from 'web/components/post';
import autosizeModifier from 'web/modifiers/autosize';

import type SessionService from 'web/services/session';
import type PostModel from 'web/models/post';

interface Signature {
  Args: {
    post: PostModel;
    onSubmit: (e: Event) => void;
    submitLabel: string;
  };
}

export default class PostFormComponent extends Component<Signature> {
  @service declare session: SessionService;

  textarea?: HTMLTextAreaElement;

  setTextarea = modifier((textarea: HTMLTextAreaElement) => {
    this.textarea = textarea;
  });

  get tagNames() {
    return this.args.post.tagNames.join(', ');
  }

  @action
  setTagNames(e: Event) {
    this.args.post.tagNames = (e.target as HTMLInputElement).value
      .split(',')
      .map((s) => s.trim())
      .filter((s) => s);
  }

  @action
  setTitle(e: Event) {
    this.args.post.title = (e.target as HTMLInputElement).value;
  }

  @action
  setBody(e: Event) {
    this.args.post.body = (e.target as HTMLTextAreaElement).value;
  }

  @action
  uploadImage(e: Event) {
    const target = e.target as HTMLInputElement;

    for (const file of target.files!) {
      const upload = new DirectUpload(
        file,
        `${ENV.appURL}/rails/active_storage/direct_uploads`,
        undefined,
        { Authorization: `Bearer ${this.session.token}` },
      );

      upload.create((error, blob) => {
        if (error) {
          console.error(error.message);
        } else if (blob) {
          const textarea = this.textarea!;

          const startPos = textarea.selectionStart;
          const endPos = textarea.selectionEnd;
          const before = textarea.value.substring(0, startPos);
          const after = textarea.value.substring(endPos);
          const text = `![${blob.filename}](${ENV.appURL}/rails/active_storage/blobs/redirect/${blob.signed_id}/${blob.filename})`;

          this.args.post.body = before + text + after;

          runTask(this, () => {
            autosize.update(textarea);

            textarea.selectionStart = textarea.selectionEnd =
              startPos + text.length;
            textarea.focus();
          });
        }
      });
    }

    target.value = '';
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
              class="form-control
                {{if (get @post.errors 'title') 'is-invalid'}}"
              {{on "input" this.setTitle}}
            />
            {{#each (get @post.errors "title") as |error|}}
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
              class="form-control {{if (get @post.errors 'body') 'is-invalid'}}"
              {{on "input" this.setBody}}
            >{{@post.body}}</textarea>
            {{#each (get @post.errors "body") as |error|}}
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
              class="form-control {{if (get @post.errors 'tags') 'is-invalid'}}"
              {{on "change" this.setTagNames}}
            />
            {{#each (get @post.errors "tags") as |error|}}
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
              class="{{if (get @post.errors 'images') 'is-invalid'}}"
              multiple
              {{on "change" this.uploadImage}}
              hidden
            />
            <label for="file" class="btn btn-outline-primary">
              Choose image
            </label>
            {{#each (get @post.errors "images") as |error|}}
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
