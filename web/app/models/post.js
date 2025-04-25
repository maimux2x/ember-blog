import { tracked } from '@glimmer/tracking';

export default class Post {
  @tracked title = '';
  @tracked body = '';
  @tracked tagNames = [];
  @tracked errors = {};

  static fromJSON(json) {
    const post = new Post();

    post.id = json.id;
    post.createdAt = json.created_at;
    post.title = json.title;
    post.body = json.body;
    post.tagNames = json.tag_names;

    return post;
  }
}
