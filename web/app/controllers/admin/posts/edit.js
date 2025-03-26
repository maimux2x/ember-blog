import Controller from '@ember/controller';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';

export default class AdminPostsEditController extends Controller {
  @service router;

  @tracked title = '';
  @tracked body = '';

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
      throw new Error('Failed to create post');
    } else {
      this.router.transitionTo('admin.posts');
    }
  }
}
