import { LinkTo } from '@ember/routing';
import Post from 'web/components/post';

<template>
  <Post @post={{@model}} />
  <LinkTo @route="index">Back</LinkTo>
</template>
