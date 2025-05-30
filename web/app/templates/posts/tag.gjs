import Post from 'web/components/post';
import Pagination from 'web/components/pagination';
import { gt } from 'ember-truth-helpers';

<template>
  <h2>Tag : {{@model.tagName}}</h2>
  <div class="posts">
    {{#each @model.posts as |post|}}
      <Post @post={{post}} @link={{true}} />
    {{/each}}
  </div>

  {{#if (gt @model.total_pages 1)}}
    <Pagination
      @route="index"
      @current={{@controller.page}}
      @last={{@model.total_pages}}
    />
  {{/if}}
</template>
