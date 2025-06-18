import { gt } from 'ember-truth-helpers';

import Pagination from 'web/components/pagination';
import Post from 'web/components/post';

import type PostModel from 'web/models/post';
import type TagController from 'web/controllers/posts/tag';
import type { TOC } from '@ember/component/template-only';

interface Signature {
  Args: {
    controller: TagController;
    model: {
      posts: PostModel[];
      tagName: string;
      totalPages: number;
    };
  };
}

<template>
  <h2>Tag : {{@model.tagName}}</h2>
  <div class="posts">
    {{#each @model.posts as |post|}}
      <Post @post={{post}} @link={{true}} />
    {{/each}}
  </div>

  {{#if (gt @model.totalPages 1)}}
    <Pagination
      @route="posts.tag"
      @current={{@controller.page}}
      @last={{@model.totalPages}}
    />
  {{/if}}
</template> satisfies TOC<Signature>;
