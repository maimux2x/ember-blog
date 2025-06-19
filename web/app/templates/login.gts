import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import ENV from 'web/config/environment';

import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';
import type { Login } from 'web/routes/login';

interface Signature {
  Args: {
    model: Login;
  };
}

export default class extends Component<Signature> {
  @service declare router: RouterService;
  @service declare session: SessionService;

  @action
  setEmail(e: Event) {
    this.args.model.email = (e as InputEvent).data ?? '';
  }

  @action
  setPassword(e: Event) {
    this.args.model.password = (e as InputEvent).data ?? '';
  }

  @action
  async createToken(e: Event) {
    e.preventDefault();

    const { model } = this.args;

    const response = await fetch(`${ENV.appURL}/api/token`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },

      body: JSON.stringify({
        email: model.email,
        password: model.password,
      }),
    });

    if (!response.ok) {
      model.error = 'Login failed';
    } else {
      const json = (await response.json()) as { token: string };
      this.session.storeToken(json.token);

      this.router.transitionTo('admin.posts');
    }
  }

  <template>
    <form {{on "submit" this.createToken}}>
      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input
          value={{@model.email}}
          id="email"
          class="form-control {{if @model.error 'is-invalid'}}"
          {{on "input" this.setEmail}}
          type="email"
        />
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input
          value={{@model.password}}
          id="password"
          class="form-control {{if @model.error 'is-invalid'}}"
          {{on "input" this.setPassword}}
          type="password"
        />
        <div class="error invalid-feedback">
          {{@model.error}}
        </div>
      </div>

      <button type="submit" class="btn btn-primary">Login</button>
    </form>
  </template>
}
