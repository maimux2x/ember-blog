import { module, test } from 'qunit';
import { setupTest } from 'web/tests/helpers';

import type SessionService from 'web/services/session';
import type { TestContext } from '@ember/test-helpers';

interface Context extends TestContext {
  service: SessionService;
}

module('Unit | Service | session', function (hooks) {
  setupTest(hooks);

  hooks.beforeEach(function (this: Context) {
    localStorage.removeItem('token');

    this.service = this.owner.lookup('service:session') as SessionService;
  });

  test('Save the token to log in', function (this: Context, assert) {
    this.service.storeToken('TOKEN');

    assert.strictEqual(this.service.isLogedIn, true);
  });

  test('Restore the token', function (this: Context, assert) {
    localStorage.setItem('token', 'TOKEN');
    this.service.restoreToken();

    assert.strictEqual(this.service.isLogedIn, true);
  });

  test('Delete the token', function (this: Context, assert) {
    this.service.storeToken('TOKEN');
    this.service.deleteToken();

    assert.strictEqual(this.service.isLogedIn, false);
  });
});
