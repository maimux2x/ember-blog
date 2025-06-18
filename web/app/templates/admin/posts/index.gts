import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import formatDatetime from 'web/helpers/format-datetime';
import Pagination from 'web/components/pagination';

import type IndexController from 'web/controllers/admin/posts/index';
import type PostModel from 'web/models/post';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';

interface Signature {
  Args: {
    controller: IndexController;
    model: {
      posts: PostModel[];
      totalPages: number;
    };
  };
}

export default class extends Component<Signature> {
  @service declare router: RouterService;
  @service declare session: SessionService;

  @action
  logout() {
    this.session.deleteToken();

    this.router.transitionTo('login');
  }

  <template>
    <div class="d-flex justify-content-end">
      <button
        type="button"
        class="btn btn-light"
        {{on "click" this.logout}}
      >Logout</button>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Created at</th>
        </tr>
      </thead>
      <tbody>
        {{#each @model.posts as |post|}}
          <tr>
            <td><LinkTo
                @route="admin.posts.edit"
                @model={{post.id}}
              >{{post.title}}</LinkTo></td>
            <td>{{formatDatetime post.createdAt}}</td>
          </tr>
        {{/each}}
      </tbody>
    </table>

    <Pagination
      @route="admin.posts"
      @current={{@controller.page}}
      @last={{@model.totalPages}}
    />

    <div class="mt-3">
      <LinkTo @route="admin.posts.new">New</LinkTo>
    </div>
  </template>
}
