import Vue from "vue";
import Router from "vue-router";

import Home from "./router/Home";
import Header from "./components/Header";

import Group from "./router/Group/Group";
import GroupNew from "./router/Group/GroupNew";
import GroupEdit from "./router/Group/GroupEdit";
import GroupDetail from "./router/Group/GroupDetail";
import GroupEvent from "./router/Group/GroupEvent";
import GroupMember from "./router/Group/GroupMember";

import EventNew from "./router/Event/EventNew";
import EventDetail from "./router/Event/EventDetail";
import EventEdit from "./router/Event/EventEdit";

import Mypage from "./router/User/Mypage";
import Login from "./router/User/Login";
import UserNew from "./router/User/UserNew";
import UserEdit from "./router/User/UserEdit";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
  // Main以外
    { path: '/', component: Home}, 
    { path: '/groups/', component: Home},
  // グループ
    { path: '/groups/new', component: GroupNew},
    { path: '/groups/:id(\\d+)', component: Group},
    //  { path: '/groups/:id', component: Group},
    { 
      path: '/groups/:id(\\d+)', 
      component: Group, 
      props: true,
      children: [
        { path: "events", component: GroupEvent },
        { path: "member", component: GroupMember },
        { path: "edit", component: GroupEdit },
        //ここからEvnet
        { path: 'events/new', component: EventNew },
        { path: 'events/:event_id(\\d+)', component: EventDetail },
        { path: 'events/:event_id(\\d+)/edit', component: EventEdit }
      ]
    },
  // ユーザー
    { path: '/users/new', component: UserNew},
    { path: '/users/:id(\\d+)', component: Mypage},
    { path: '/users/:id(\\d+)/edit', component: UserEdit},
    { path: '/login', component: Login},
  // その他
    {
      path: '*', 
      redirect: '/'
    }
  ]
});