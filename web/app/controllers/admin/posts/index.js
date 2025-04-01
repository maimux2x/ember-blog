import Controller from '@ember/controller';
import { action } from '@ember/object';
import { Toast } from 'bootstrap';
import { tracked } from '@glimmer/tracking';

export default class AdminPostsIndexController extends Controller {
  queryParams = ['status'];
  _status = null;

  @tracked showToastFlag = false;
  @tracked toastMessage = '';

  set status(value) {
    this._status = value;
    switch (value) {
      case 'created':
        this.toastMessage = 'Createing a post is succesfully.';
        this.showToast();
        break;
      case 'updated':
        this.toastMessage = 'Updateing a post is succesfully.';
        this.showToast();
        break;
    }
  }

  get status() {
    return this._status;
  }

  @action
  showToast() {
    this.showToastFlag = true;

    requestAnimationFrame(() => {
      const toastElement = document.getElementById('postMessage');
      const toast = new Toast(toastElement);
      toast.show();
    });

    this.status = null;
  }
}
