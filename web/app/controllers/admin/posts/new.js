import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AdminPostsNewController extends Controller {
  @service router;
  @service toast;
  @service session;

  @action
  async createPost(event) {
    event.preventDefault();

    const response = await fetch('http://localhost:3000/posts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.session.token}`,
      },

      body: JSON.stringify({
        post: {
          title: this.model.title,
          body: this.model.body,
          image: this.model.image,
        },
      }),
    });

    if (!response.ok) {
      const json = await response.json();
      this.model.errors = json.errors;
    } else {
      this.router.transitionTo('admin.posts');

      this.toast.show('Post created successfully', 'success');
    }
  }
}
