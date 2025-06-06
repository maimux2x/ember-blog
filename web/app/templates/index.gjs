import Component from '@glimmer/component';
import Pagination from 'web/components/pagination';
import Post from 'web/components/post';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { gt } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import { runTask } from 'ember-lifeline';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class extends Component {
  @service session;
  @service router;

  @tracked _query = '';

  @action
  setQuery(e) {
    this._query = e.target.value;
  }

  @action
  search(e) {
    e.preventDefault();
    this.args.controller.query = this._query;
    this.args.controller.page = 1;

    runTask(this, () => {
      this.router.refresh();
    });
  }

  @action
  cancel() {
    this.args.controller.query = this._query = '';
    this.args.controller.page = 1;

    runTask(this, () => {
      this.router.refresh();
    });
  }

  <template>
    <div class="mb-3">
      <form class="d-flex" role="search" {{on "submit" this.search}}>
        <input
          value={{this._query}}
          class="form-control me-2"
          placeholder="Search"
          aria-labelledby="button-search"
          {{on "input" this.setQuery}}
        />
        <button
          class="btn btn-outline-success me-2"
          type="submit"
        >Search</button>
        <button
          class="btn btn-outline-secondary"
          type="button"
          {{on "click" this.cancel}}
        >Cancel</button>
      </form>
    </div>
    <div class="posts">
      {{#each @model.posts as |post|}}
        <Post @post={{post}} @link={{true}} />
      {{/each}}
    </div>

    {{#if (gt @model.total_pages 1)}}
      <Pagination
        @route="index"
        @current={{@controller.page}}
        @last={{@model.total_pages}}
      />
    {{/if}}

    {{#if this.session.isLogedIn}}
      <LinkTo @route="admin.posts">admin</LinkTo>
    {{else}}
      <LinkTo @route="login">login</LinkTo>
    {{/if}}
  </template>
}
