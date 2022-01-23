<template>
  <div>
    <v-dialog
      v-model="showContent"
      width="500"
      @click:outside="$emit('close')"
    >
      <v-card>
        <v-card-title class="text-h5 grey lighten-2">
          削除します。よろしいですか？
        </v-card-title>

        <v-card-text>
          この操作は取り消せません。
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="primary"
            text
            @click="$emit('close')"
          >
            キャンセル
          </v-btn>
          <v-btn
            color="error"
            text
            @click="$emit('delete')"
          >
            削除
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>  
  </div>
</template>

<script>
export default {

  props: {
    showContent: {
      type: Boolean
    }
  },

}
</script>