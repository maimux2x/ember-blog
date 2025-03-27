import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AdminPostsEditController extends Controller {
  @service router;

  @action
  async updatePost(event) {
    event.preventDefault();

    const response = await fetch(
      `http://localhost:3000/posts/${this.model.id}`,
      {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },

        body: JSON.stringify({
          post: {
            title: this.model.title,
            body: this.model.body,
          },
        }),
      },
    );

    if (!response.ok) {
      const json = await response.json();
      this.model.errors = json.errors;
    } else {
      this.router.transitionTo('admin.posts');
    }
  }

  @action
  async deletePost() {
    if (!confirm('Do you really want to delete?')) {
      return;
    }

    const response = await fetch(
      `http://localhost:3000/posts/${this.model.id}`,
      {
        method: 'DELETE',
      },
    );

    if (!response.ok) {
      throw new Error('Faild to delete post');
    } else {
      this.router.transitionTo('admin.posts');
    }
  }
}
