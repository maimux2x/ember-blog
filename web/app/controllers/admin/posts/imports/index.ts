import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

export default class AdminPostsCsvImportsIndexController extends Controller {
  queryParams = [
    {
      page: { type: 'number' },
    } as const,
  ];

  @tracked page = 1;
}
