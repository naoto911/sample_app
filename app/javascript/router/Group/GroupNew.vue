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
      

    <!-- ここから ①-1 画像uploda -->

      <!-- <v-file-input
        v-model="group.image"
        label="File input"
        filled
        prepend-icon="mdi-camera"
        type="file" 
        v-on:change="setImage"
      ></v-file-input> -->
        <!-- <p>{{ group.image }}</p> -->

      <input type="file" v-on:change="setImage" />
      <br>
      <br>
    <!-- ここまで ①-1 画像uploda -->

      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="createGroup"
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
import axios from 'axios';

export default {
  data() {
    return {
      valid: true,
      current_user: {},
      group: {
        name: '',
        adminuser_id: '',
        introduction: '',
        image: ''
      },
      image: '',
      uploadedImage: '',
      name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      select: null,
    }
  },

  created() {
    this.getGroup();
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
    getGroup() {
      axios
        .get('/api/v1/groups/new.json')
        .then(response => {
        this.current_user = response.data.current_user;
      });
    },
    createGroup () {
      if (!this.group.name) return;
      const formData = new FormData()
      formData.append('group[name]', this.group.name)
      formData.append('group[adminuser_id]', this.current_user.id)
      formData.append('group[introduction]', this.group.introduction)
      formData.append('group[image]', this.image)

      axios
        .post('/api/v1/groups', formData)
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

}
</script>