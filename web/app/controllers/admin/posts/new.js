import Controller from '@ember/controller';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

export default class AdminPostsNewController extends Controller {
  @tracked title = '';
  @tracked body  = '';

  @action
  async createPost(event) {
    event.preventDefault();

    const newPost = {
      title: this.title,
      body: this.body,
    };

    const response = await fetch('http://localhost:3000/posts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },

      body: JSON.stringify({ post: newPost }),
    });

    if (!response.ok) {
      throw new Error('Failed to create post');
    }
  }
}
