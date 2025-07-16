import { setupTest } from 'web/tests/helpers';
import { module, test } from 'qunit';
import Post from 'web/models/post';

module('Unit | Model | post', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    const json = {
      id: 1,
      created_at: '2025-07-01T01:04:51Z',
      title: 'test',
      body: 'Hello world',
      tag_names: ['test1', 'test2'],
    };

    const post = Post.fromJSON(json);

    assert.strictEqual(post.id, 1);
    assert.strictEqual(
      post.createdAt.toISOString(),
      '2025-07-01T01:04:51.000Z',
    );
    assert.strictEqual(post.title, 'test');
    assert.strictEqual(post.body, 'Hello world');
    assert.deepEqual(post.tagNames, ['test1', 'test2']);
  });
});
