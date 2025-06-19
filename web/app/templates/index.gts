import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

import { runTask } from 'ember-lifeline';

import Pagination from 'web/components/pagination';
import Post from 'web/components/post';

import type IndexController from 'web/controllers/index';
import type PostModel from 'web/models/post';
import type RouterService from '@ember/routing/router-service';

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

  @tracked _query = '';

  @action
  setQuery(e: Event) {
    this._query = (e.target as HTMLInputElement).value;
  }

  @action
  search(e: SubmitEvent) {
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

    <Pagination
      @route="index"
      @current={{@controller.page}}
      @last={{@model.totalPages}}
    />
  </template>
}
