import Component from '@glimmer/component';
import { DirectUpload } from '@rails/activestorage/src/direct_upload';
import { action } from '@ember/object';

export default class PostFormComponent extends Component {
  @action
  uploadImage(e) {
    const upload = new DirectUpload(
      e.target.files[0],
      'http://localhost:3000/rails/active_storage/direct_uploads',
      {},
    );

    upload.create((error, blob) => {
      this.args.post.image = blob.signed_id;
    });
  }
}
