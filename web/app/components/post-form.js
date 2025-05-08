import Component from '@glimmer/component';
import { DirectUpload } from '@rails/activestorage/src/direct_upload';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';
import { runTask } from 'ember-lifeline';
import autosize from 'autosize';
import ENV from 'web/config/environment';

export default class PostFormComponent extends Component {
  setTextarea = modifier((textarea) => {
    this.textarea = textarea;
  });

  get tagNames() {
    return this.args.post.tagNames.join(', ');
  }

  @action
  setTagNames(e) {
    this.args.post.tagNames = e.target.value.split(',').map((s) => s.trim());
  }

  @action
  uploadImage(e) {
    for (const file of e.target.files) {
      const upload = new DirectUpload(
        file,
        `${ENV.apiURL}/rails/active_storage/direct_uploads`,
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
          const text = `![${blob.filename}](${ENV.apiURL}/rails/active_storage/blobs/redirect/${blob.signed_id}/${blob.filename})`;

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
}
