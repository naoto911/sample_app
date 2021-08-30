<template>
  <div>
    <!-- <p>ここにJoinNewを表示</p> -->
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      <!-- <v-text-field
        v-model="group.name"
        :counter="10"
        :rules="nameRules"
        label="Name"
        required
      ></v-text-field> -->

      <v-text-field
        v-model="join.content"
        label="Introduction"
        required
      ></v-text-field>

      <v-btn
        color="success"
        class="mr-4"
        dark
        @click="createApplication"
      >
        Application
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
import axios from 'axios';

  export default {
    data: () => ({
      valid: true,
      current_user: {},
      join: {},
      name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      select: null,
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
      createApplication () {
        if (!this.join.content) return;
        const formData = new FormData()
        formData.append('join[content]', this.join.content)
        formData.append('join[user_id]', this.current_user.id)
        formData.append('join[group_id]', this.$route.params.id)
        formData.append('join[level]', 2)
          axios
            .post(`/api/v1/groups/${this.$route.params.id}/join`, formData)
            .then(response => {
              console.log('OK');
              console.log(this.group);
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
  //mountedでVueインスタンスのDOM作成完了直後に読み込む 画面取得用
    mounted() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/joins/new.json`)
        .then(response => {
        this.join = response.data.join;
        this.current_user = response.data.current_user;
      });
    }
  }
</script>