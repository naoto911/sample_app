import Vue from "vue";
import Router from "vue-router";
import Home from "./router/Home";
import Group from "./router/Group";
// import GroupDetail from "./router/GroupDetail";
import GroupNew from "./router/GroupNew";
import GroupEvent from "./router/GroupEvent";
import GroupMember from "./router/GroupMember";
import GroupEdit from "./router/GroupEdit";


Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
    { path: '/', component: Home}, 
    { path: '/groups/', component: Home}, 
    { path: '/groups/new', component: GroupNew},
    { path: '/groups/:id(\\d+)', component: Group},
    //  { path: '/groups/:id', component: Group},
    { 
      path: '/groups/:id(\\d+)', 
      component: Group, 
      props: true,
      children: [
        { path: "event", component: GroupEvent },
        { path: "member", component: GroupMember },
        { path: "edit", component: GroupEdit },
      ]
    },
    {
      path: '*', 
      redirect: '/'
    }
  ]
});