import { tracked } from '@glimmer/tracking';

export interface PostJSON {
  id: number;
  published_at: string;
  title: string;
  body: string;
  tag_names: string[];
}

export default class Post {
  @tracked title = '';
  @tracked body = '';
  @tracked tagNames: string[] = [];
  @tracked errors: Record<string, string[]> = {};

  id?: number;
  publishedAt?: Date;

  static fromJSON(json: PostJSON) {
    const post = new Post();

    post.id = json.id;
    post.publishedAt = new Date(json.published_at);
    post.title = json.title;
    post.body = json.body;
    post.tagNames = json.tag_names;

    return post;
  }
}
