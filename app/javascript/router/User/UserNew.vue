<template>
  <div>
    <h1>新規アカウント作成</h1>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      <v-text-field
        v-model="user.name"
        :counter="10"
        label="namae "
        required
      ></v-text-field>

      <v-text-field
        v-model="user.email"
        :counter="10"
        label="Email"
        required
      ></v-text-field>

      <v-text-field
        v-model="user.password"
        :counter="10"
        label="Password"
        required
      ></v-text-field>

      <v-text-field
        v-model="user.password_confirmation"
        label="Password Confirmation"
        required
      ></v-text-field>
      
      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="createUser"
      >
        作成
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
        リセット
      </v-btn>

    </v-form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      user: {},
      // user: {
      //   image: null,
      //   name: null,
      //   frequency: '2',
      //   region: null,
      //   instagram: null,
      //   introduction: null,

      //   url: null,
      // },
    }
  },

  created() {
    this.getUser();
  },

  methods: {
    // validate () {
    //   this.$refs.form.validate()
    // },
    // resetValidation () {
    //   this.$refs.form.resetValidation()
    // },
    reset () {
      this.$refs.form.reset()
    },
    getUser(){
      axios
        .get(`/api/v1/users/new.json`)
        .then(response => {
          this.user = response.data.user;
        });
    },
    createUser () {
      if (!this.user.name) return;

        axios
          .post('/api/v1/users', {
            user: {              
              name: this.user.name,
              email: this.user.email,
              password: this.user.password,
              password_confirmation: this.user.password_confirmation
            }
          })
        .then(response => {
          console.log('OK');
          console.log(this.user);
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
  },

}

</script>