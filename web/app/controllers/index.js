import Controller from '@ember/controller';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { runTask } from 'ember-lifeline';

export default class IndexController extends Controller {
  queryParams = [
    {
      page: { type: 'number' },
      query: { type: 'string' },
    },
  ];

  @service session;
  @service router;

  @tracked page = 1;
  @tracked query = '';
  @tracked _query = '';

  @action
  search(e) {
    e.preventDefault();
    this.query = this._query;
    this.page = 1;

    runTask(this, () => {
      this.router.refresh();
    });
  }

  @action
  cancel() {
    this.query = '';
    this._query = '';
    this.page = 1;

    runTask(this, () => {
      this.router.refresh();
    });
  }
}
