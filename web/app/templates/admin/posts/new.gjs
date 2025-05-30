import Component from '@glimmer/component';
import PostForm from 'web/components/post-form';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { service } from '@ember/service';
import ENV from 'web/config/environment';

export default class extends Component {
  @service router;
  @service toast;
  @service session;

  @action
  async createPost(event) {
    event.preventDefault();

    const { model } = this.args;

    const response = await fetch(`${ENV.apiURL}/posts`, {
      method: 'POST',
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

      this.toast.show('Post created successfully', 'success');
    }
  }

  <template>
    <h2>New Post</h2>

    <PostForm
      @onSubmit={{this.createPost}}
      @post={{@model}}
      @submitLabel="Create"
    />

    <div class="mt-3">
      <LinkTo @route="admin.posts">Back</LinkTo>
    </div>
  </template>
}
