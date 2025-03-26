import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AdminPostsIndexController extends Controller {
  @service router;

  @action
  async delete(post) {
    if (!confirm('Do you really want to delete?')) {
      return;
    }

    const response = await fetch(`http://localhost:3000/posts/${post.id}`, {
      method: 'DELETE',
    });

    if (!response.ok) {
      throw new Error('Faild to delete post');
    } else {
      this.router.refresh();
    }
  }
}
