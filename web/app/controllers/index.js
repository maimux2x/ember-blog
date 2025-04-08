import Controller from '@ember/controller';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class IndexController extends Controller {
  queryParams = [
    {
      page: { type: 'number' },
    },
  ];

  @service session;
  @tracked page = 1;
}
