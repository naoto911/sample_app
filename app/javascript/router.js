import Vue from "vue";
import Router from "vue-router";
import Home from "./components/Home";
import Group from "./components/Group";
import GroupDetail from "./components/GroupDetail";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
    { path: '/', component: Home}, 
    { path: '/groups/', component: Home}, 
    { path: '/groups/:id(\\d+)', component: GroupDetail},
    {
      path: '*', 
      redirect: '/'
    }
  ]
});