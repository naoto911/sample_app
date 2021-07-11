<template>
  <div>
    <h1>Create account</h1>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      <v-text-field
        v-model="user.name"
        :counter="10"
        label="Name"
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
        Create
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
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      user: {}
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
    setImage (e) {
      this.image = e.target.files[0]
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

  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get(`/api/v1/users/new.json`)
      .then(response => {
        // this.group = response.data.group;
        this.user = response.data.user;
      });
  }
}

</script>