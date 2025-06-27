import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import ENV from 'web/config/environment';
import PostForm from 'web/components/post-form';

import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';
import type ToastService from 'web/services/toast';
import type PostModel from 'web/models/post';
import type { paths } from 'schema/openapi';

type InvalidPayload =
  paths['/posts/{id}']['patch']['responses']['422']['content']['application/json'];

interface Signature {
  Args: {
    model: PostModel;
  };
}

export default class extends Component<Signature> {
  @service declare router: RouterService;
  @service declare toast: ToastService;
  @service declare session: SessionService;

  @action
  async updatePost(e: Event) {
    e.preventDefault();

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
      const json = (await response.json()) as InvalidPayload;

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
