<template>
  <div>
    <h1>Login</h1>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      <v-text-field
        v-model="user.email"
        :counter="30"
        label="E-mail"
        required
      ></v-text-field>

      <v-text-field
        v-model="user.password"
        label="password"
        required
      ></v-text-field>
      
      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="dologin"
      >
        Login
        <v-icon
          dark
          right
        >
          mdi-checkbox-marked-circle
        </v-icon>
      </v-btn>

      <v-btn
        color="error"
        class="mr-4"
        @click="reset"
      >
        Reset Form
      </v-btn>

    </v-form>
    <hr>
    <p>まだ新規登録していない方は、
      <router-link
        to="/users/new"
        active-class="link--active"
        exact
        class="link"
      >こちら</router-link>
    より新規登録を行ってください。</p>
  </div>
</template>

<script>
import axios from 'axios';

axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data() {
    return {
      valid: true,
      current_user: {},
      user: {
        email: '',
        password: ''
      }
    }
  },

  methods: {
    validate () {
      this.$refs.form.validate()
    },
    reset () {
      this.$refs.form.reset()
    },
    resetValidation () {
      this.$refs.form.resetValidation()
    },
    dologin () {
      if (!this.user.email) return;

      axios
        .post('/api/v1/login', {
            email: this.user.email,
            password: this.user.password
        })
      .then(response => {
        console.log('OK');
        this.$router.push({ path: '/' });
      })        
      .catch(error => {
        console.log('NG');
        console.error(error);
        if(error.response.data && error.response.data.errors) {
          this.errors = error.response.data.errors;
        }
      })
    }

  }
}
</script>