import Component from '@glimmer/component';
import PostForm from 'web/components/post-form';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { service } from '@ember/service';

import ENV from 'web/config/environment';

import type PostModel from 'web/models/post';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';
import type ToastService from 'web/services/toast';
import type { paths } from 'schema/openapi';

type InvalidPayload =
  paths['/posts']['post']['responses']['422']['content']['application/json'];

interface Signature {
  model: PostModel;
}

export default class extends Component<Signature> {
  @service declare router: RouterService;
  @service declare toast: ToastService;
  @service declare session: SessionService;

  @action
  async createPost(e: Event) {
    e.preventDefault();

    const { model } = this.args;

    const response = await fetch(`${ENV.appURL}/api/posts`, {
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
      const json = (await response.json()) as InvalidPayload;

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
