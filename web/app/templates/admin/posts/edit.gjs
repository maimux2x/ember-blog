import Component from '@glimmer/component';
import PostForm from 'web/components/post-form';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import ENV from 'web/config/environment';

export default class extends Component {
  @service router;
  @service toast;
  @service session;

  @action
  async updatePost(event) {
    event.preventDefault();

    const { model } = this.args;

    const response = await fetch(`${ENV.appURL}/api/posts/${model.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.session.token}`,
      },

      body: JSON.stringify({
        post: {
          title: model.title,
          body: model.body,
          tag_names: model.tagNames,
        },
      }),
    });

    if (!response.ok) {
      const json = await response.json();
      model.errors = json.errors;
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

    const response = await fetch(
      `${ENV.appURL}/api/posts/${this.args.model.id}`,
      {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${this.session.token}`,
        },
      },
    );

    if (!response.ok) {
      throw new Error('Faild to delete post');
    } else {
      this.router.transitionTo('admin.posts');

      this.toast.show('Post deleted successfully', 'success');
    }
  }

  <template>
    <h2>Edit Post</h2>

    <PostForm
      @onSubmit={{this.updatePost}}
      @post={{@model}}
      @submitLabel="Update"
    />

    <hr />

    <div class="mt-3">
      <button
        type="button"
        class="btn btn-danger"
        {{on "click" this.deletePost}}
      >Delete</button>
    </div>

    <div class="mt-3">
      <LinkTo @route="admin.posts">Back</LinkTo>
    </div>
  </template>
}
