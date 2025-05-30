import Component from '@glimmer/component';
import formatDatetime from 'web/helpers/format-datetime';
import Pagination from 'web/components/pagination';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { gt } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

export default class extends Component {
  @service router;
  @service session;

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
            <td>{{formatDatetime post.created_at}}</td>
          </tr>
        {{/each}}
      </tbody>
    </table>

    {{#if (gt @model.total_pages 1)}}
      <Pagination
        @route="admin.posts"
        @current={{@controller.page}}
        @last={{@model.total_pages}}
      />
    {{/if}}

    <div class="mt-3">
      <LinkTo @route="admin.posts.new">New</LinkTo>
    </div>
  </template>
}
