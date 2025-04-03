import EmberRouter from '@ember/routing/router';
import config from 'web/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('posts', function () {
    this.route('show', { path: '/:post_id' });
  });

  this.route('admin', function () {
    this.route('posts', function () {
      this.route('new');
      this.route('edit', { path: 'edit/:post_id' });
    });
  });

  this.route('login');
  this.route('logout');
});
