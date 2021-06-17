<template>
  <div>
  <v-form
    ref="form"
    v-model="valid"
    lazy-validation
  >
    <v-text-field
      v-model="group.name"
      :counter="10"
      :rules="nameRules"
      label="Name"
      required
    ></v-text-field>

    <v-text-field
      v-model="group.introduction"
      label="Introduction"
      required
    ></v-text-field>

    <v-btn
      color="primary"
      class="mr-4"
      dark
      @click="createGroup"
    >
      Update
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
      current_user: [],
      // group: {},
      group: [],
      name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      // email: '',
      // emailRules: [
      //   v => !!v || 'E-mail is required',
      //   v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      // ],
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
      createGroup () {
        if (!this.group.name) return;
        axios
          .patch(`/api/v1/groups/${this.$route.params.id}`, {
            // group: this.group,
            // current_user: this.current_user
            group: { name: this.group.name,
                     adminuser_id: this.group.adminuser_id.id, 
                     introduction: this.group.introduction, 
                     image: this.group.image
                    }
            // this.group: { name: this.name,
            // name: this.name,
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
    },
  //作成済のgroup情報を取得
    mounted() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/edit.json`)
        .then(response => {
        this.group = response.data.group;
        // this.current_user = response.data.current_user;
      });
    }
  }
</script>