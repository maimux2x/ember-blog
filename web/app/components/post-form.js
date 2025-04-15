import Component from '@glimmer/component';
import { DirectUpload } from '@rails/activestorage/src/direct_upload';
import { action } from '@ember/object';

export default class PostFormComponent extends Component {
  @action
  uploadImage(e) {
    this.args.post.images = [];

    for (const file of e.target.files) {
      const upload = new DirectUpload(
        file,
        'http://localhost:3000/rails/active_storage/direct_uploads',
        {},
      );

      upload.create((error, blob) => {
        if (error) {
          console.error(error.message);
        } else {
          this.args.post.images.push(blob.signed_id);
        }
      });
    }
  }
}
