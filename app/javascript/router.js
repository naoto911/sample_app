import Vue from "vue";
import Router from "vue-router";
import Home from "./router/Home";
import Group from "./router/Group";
import GroupDetail from "./router/GroupDetail";
import GroupNew from "./router/GroupNew";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
    { path: '/', component: Home}, 
    { path: '/groups/', component: Home}, 
    { path: '/groups/:id(\\d+)', component: GroupDetail},
    { path: '/groups/new', component: GroupNew},
    {
      path: '*', 
      redirect: '/'
    }
  ]
});