<template>
  <div>
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
      
      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="UpdateEdit"
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
  data() {
    return {
      user: {}
    }
  },

  created() {
    this.getUser();
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
    getUser() {
      axios
        .get(`/api/v1/users/${this.$route.params.id}/edit.json`)
        .then(response => {
        this.user = response.data.user;
      });
    },
    UpdateEdit () {
      if (!this.user.name) return;
      axios
        .patch(`/api/v1/users/${this.$route.params.id}`, {
          user: {  name: this.user.name,
                    email: this.user.email,
                  }
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
  
}
</script>