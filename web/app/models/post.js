import { tracked } from '@glimmer/tracking';

export default class Post {
  @tracked title = '';
  @tracked body = '';
  @tracked errors = {};
}
