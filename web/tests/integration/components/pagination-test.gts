import { module, test } from 'qunit';
import { setupRenderingTest } from 'web/tests/helpers';
import { render } from '@ember/test-helpers';

import Pagination from 'web/components/pagination';

module('Integration | Component | pagination', function (hooks) {
  setupRenderingTest(hooks);

  test('last が 1 の場合はページネーションが表示されない', async function (assert) {
    await render(
      <template>
        <Pagination @route="index" @current={{1}} @last={{1}} />
      </template>,
    );

    assert.equal((this.element as HTMLElement).innerText, '');
  });

  test('current=1, last=3', async function (assert) {
    await render(
      <template>
        <Pagination @route="index" @current={{1}} @last={{3}} />
      </template>,
    );

    assert.dom('[data-test-start]').hasClass('disabled');
    assert.dom('[data-test-start] a').hasAttribute('href', '#');

    assert.dom('[data-test-prev]').hasClass('disabled');
    assert.dom('[data-test-prev] a').hasAttribute('href', '#');

    assert.dom('[data-test-page="1"]').hasClass('active');
    assert.dom('[data-test-page="1"] a').hasAttribute('href', '/');

    assert.dom('[data-test-page="2"]').doesNotHaveClass('active');
    assert.dom('[data-test-page="2"] a').hasAttribute('href', '/?page=2');

    assert.dom('[data-test-page="3"]').doesNotHaveClass('active');
    assert.dom('[data-test-page="3"] a').hasAttribute('href', '/?page=3');

    assert.dom('[data-test-next]').doesNotHaveClass('disabled');
    assert.dom('[data-test-next] a').hasAttribute('href', '/?page=2');

    assert.dom('[data-test-last]').doesNotHaveClass('disabled');
    assert.dom('[data-test-last] a').hasAttribute('href', '/?page=3');
  });

  test('current=2, last=3', async function (assert) {
    await render(
      <template>
        <Pagination @route="index" @current={{2}} @last={{3}} />
      </template>,
    );

    assert.dom('[data-test-start]').doesNotHaveClass('disabled');
    assert.dom('[data-test-start] a').hasAttribute('href', '/');

    assert.dom('[data-test-prev]').doesNotHaveClass('disabled');
    assert.dom('[data-test-prev] a').hasAttribute('href', '/');

    assert.dom('[data-test-page="1"]').doesNotHaveClass('active');
    assert.dom('[data-test-page="2"]').hasClass('active');
    assert.dom('[data-test-page="3"]').doesNotHaveClass('active');

    assert.dom('[data-test-next]').doesNotHaveClass('disabled');
    assert.dom('[data-test-next] a').hasAttribute('href', '/?page=3');

    assert.dom('[data-test-last]').doesNotHaveClass('disabled');
    assert.dom('[data-test-last] a').hasAttribute('href', '/?page=3');
  });

  test('current=3, last=3', async function (assert) {
    await render(
      <template>
        <Pagination @route="index" @current={{3}} @last={{3}} />
      </template>,
    );

    assert.dom('[data-test-start]').doesNotHaveClass('disabled');
    assert.dom('[data-test-start] a').hasAttribute('href', '/');

    assert.dom('[data-test-prev]').doesNotHaveClass('disabled');
    assert.dom('[data-test-prev] a').hasAttribute('href', '/?page=2');

    assert.dom('[data-test-page="1"]').doesNotHaveClass('active');
    assert.dom('[data-test-page="2"]').doesNotHaveClass('active');
    assert.dom('[data-test-page="3"]').hasClass('active');

    assert.dom('[data-test-next]').hasClass('disabled');
    assert.dom('[data-test-next] a').hasAttribute('href', '#');

    assert.dom('[data-test-last]').hasClass('disabled');
    assert.dom('[data-test-last] a').hasAttribute('href', '#');
  });
});
