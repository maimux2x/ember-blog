import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';
import ENV from 'web/config/environment';

export default class AdminPostsEditController extends Controller {
  @service router;
  @service toast;
  @service session;

  @action
  async updatePost(event) {
    event.preventDefault();

    const response = await fetch(`${ENV.apiURL}/posts/${this.model.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.session.token}`,
      },

      body: JSON.stringify({
        post: {
          title: this.model.title,
          body: this.model.body,
          tag_names: this.model.tagNames,
        },
      }),
    });

    if (!response.ok) {
      const json = await response.json();
      this.model.errors = json.errors;
    } else {
      this.router.transitionTo('admin.posts');

      this.toast.show('Post updated successfully', 'success');
    }
  }

  @action
  async deletePost() {
    if (!confirm('Do you really want to delete?')) {
      return;
    }

    const response = await fetch(`${ENV.apiURL}/posts/${this.model.id}`, {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${this.session.token}`,
      },
    });

    if (!response.ok) {
      throw new Error('Faild to delete post');
    } else {
      this.router.transitionTo('admin.posts');

      this.toast.show('Post deleted successfully', 'success');
    }
  }
}
