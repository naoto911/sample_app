<template>
  <div>
    <!-- <p>ここにJoinNewを表示</p> -->
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >

      <v-text-field
        v-model="join.content"
        label="Introduction"
        required
      ></v-text-field>

      <v-btn
        color="success"
        class="mr-4"
        dark
        @click="updateApplication"
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
      updateApplication () {
        if (!this.join.content) return;

        axios
          .patch(`/api/v1/groups/${this.$route.params.id}/joins/${this.$route.params.join_id}`, {
            join: {           
              content: this.join.content,   
              user_id: this.join.user_id,
              group_id: this.join.group_id,
              level: this.join.level
            }
          })

          .then(response => {
            console.log('OK');
            console.log(this.user);
            this.$router.push({ path: `/api/v1/groups/${this.$route.params.id}/detail` });
          })        
          .catch(error => {
            console.log('NG');
            console.error(error);
            if(error.response.data && error.response.data.errors) {
              this.errors = error.response.data.errors;
            }
          })
      },
      getJoin() {
        axios
          .get(`/api/v1/groups/${this.$route.params.id}/joins/${this.$route.params.join_id}.json`)
          .then(response => {
            this.join = response.data.join;
          });
      },
    },

    created () {
      this.getJoin();
    },
  }
</script>