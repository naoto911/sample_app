<template>
  <div>
    <p>{{ current_user.id }}</p>
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

    <v-select
      v-model="select"
      :items="items"
      :rules="[v => !!v || 'Item is required']"
      label="Item"
      required
    ></v-select>

    <!-- <v-checkbox
      v-model="checkbox"
      :rules="[v => !!v || 'You must agree to continue!']"
      label="Do you agree?"
      required
    ></v-checkbox> -->

    <!-- <v-btn
      :disabled="!valid"
      color="success"
      class="mr-4"
      @click="validate"
    >
      Validate
    </v-btn> -->

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

    <!-- <v-btn
      color="primary"
      class="mr-4"
      @click="reset"
    >
      Create
    </v-btn> -->

    <v-btn
      color="error"
      class="mr-4"
      @click="reset"
    >
      Reset Form
    </v-btn>

    <!-- <v-btn
      color="warning"
      @click="resetValidation"
    >
      Reset Validation
    </v-btn> -->
  </v-form>
  </div>
</template>

<script>
import axios from 'axios';

  export default {
    data: () => ({
      valid: true,
      current_user: {},
      group: {
        name: '',
        adminuser_id: '',
        introduction: '',
        image: ''
      },
      // group: [],
      name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      email: '',
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      select: null,
      items: [
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
      ],
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
          .post('/api/v1/groups', {
            // group: this.group,
            // current_user: this.current_user
            group: { name: this.group.name,
                     adminuser_id: this.current_user.id, 
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
  //mountedでVueインスタンスのDOM作成完了直後に読み込む 画面取得用
    mounted() {
      axios
        .get('/api/v1/groups/new.json')
        .then(response => {
        // this.group = response.data.group;
        this.current_user = response.data.current_user;
      });
    }
  }
</script>