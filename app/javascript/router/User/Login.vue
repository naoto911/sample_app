<template>
  <div>
    <h1>Login</h1>
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
        v-model="user.password"
        label="password"
        required
      ></v-text-field>
      
      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="reset"
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

  export default {
    data: () => ({
      valid: true,
      current_user: {},
      user: {
        name: '',
        password: ''
      }
    }),

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
  //     createGroup () {
  //       if (!this.group.name) return;
  //       const formData = new FormData()
  //       formData.append('group[name]', this.group.name)
  //       formData.append('group[adminuser_id]', this.current_user.id)
  //       formData.append('group[introduction]', this.group.introduction)
  //       formData.append('group[image]', this.image)
  //         axios
  //         .post('/api/v1/groups', formData)
  //         .then(response => {
  //           console.log('OK');
  //           console.log(this.group);
  //           this.$router.push({ path: '/' });
  //         })        
  //         .catch(error => {
  //           console.log('NG');
  //           console.error(error);
  //           if(error.response.data && error.response.data.errors) {
  //             this.errors = error.response.data.errors;
  //           }
  //         })
  //     } 
  //   },
  // //mountedでVueインスタンスのDOM作成完了直後に読み込む 画面取得用
  //   mounted() {
  //     axios
  //       .get('/api/v1/groups/new.json')
  //       .then(response => {
  //       // this.group = response.data.group;
  //       this.current_user = response.data.current_user;
  //     });
    }
  }
</script>