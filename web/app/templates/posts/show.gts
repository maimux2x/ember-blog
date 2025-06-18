import { LinkTo } from '@ember/routing';

import Post from 'web/components/post';

import type PostModel from 'web/models/post';
import type { TOC } from '@ember/component/template-only';

interface Signature {
  model: PostModel;
}

<template>
  <Post @post={{@model}} />
  <LinkTo @route="index">Back</LinkTo>
</template> satisfies TOC<Signature>;
