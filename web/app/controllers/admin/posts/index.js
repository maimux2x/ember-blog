import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

export default class AdminPostsIndexController extends Controller {
  queryParams = [
    {
      page: { type: 'number' },
    },
  ];

  @tracked page = 1;
}
