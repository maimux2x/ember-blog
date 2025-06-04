import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

export default class IndexController extends Controller {
  queryParams = [
    {
      page: { type: 'number' },
      query: { type: 'string' },
    },
  ];

  @tracked page = 1;
  @tracked query = '';
}
