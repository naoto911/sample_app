import Vue from "vue";
import Router from "vue-router";

import Home from "./router/Home";
// import Header from "./components/Header";

import Group from "./router/Group/Group";
import GroupNew from "./router/Group/GroupNew";
import GroupEdit from "./router/Group/GroupEdit";
import GroupDetail from "./router/Group/GroupDetail";
import GroupEvent from "./router/Group/GroupEvent";
import GroupMember from "./router/Group/GroupMember";

import Approval from "./router/Group/Approval";

import EventNew from "./router/Event/EventNew";
import EventDetail from "./router/Event/EventDetail";
import EventEdit from "./router/Event/EventEdit";

import JoinNew from "./router/Join/JoinNew";
import JoinEdit from "./router/Join/JoinEdit";

import User from "./router/User/User";
import UserNew from "./router/User/UserNew";
import UserEdit from "./router/User/UserEdit";
import UserProfile from "./router/User/UserProfile";
import UserEvent from "./router/User/UserEvent";
import UserFavorite from "./router/User/UserFavorite";
import Application from "./router/User/Application";

import Login from "./router/User/Login";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
  // Main以外
    { path: '/', component: Home}, 
    { path: '/groups/', component: Home},
  // グループ
    { path: '/groups/new', component: GroupNew},
    // { path: '/groups/:id(\\d+)', component: Group},
    //  { path: '/groups/:id', component: Group},
    { 
      path: '/groups/:id(\\d+)', 
      component: Group, 
      props: true,
      children: [
        { path: "detail", component: GroupDetail },
        { path: "events", component: GroupEvent },
        { path: "member", component: GroupMember },
        // { path: "edit", component: GroupEdit },
        //承認関連
        { path: "approval", component: Approval },
        //ここからEvnet
        { path: 'events/new', component: EventNew },
        { path: 'events/:event_id(\\d+)', component: EventDetail },
        { path: 'events/:event_id(\\d+)/edit', component: EventEdit },
        //ここからJoin
        { path: 'joins/new', component: JoinNew },
        { path: 'joins/:join_id(\\d+)/edit', component: JoinEdit },
      ]
    },
    //editのみは別記載
    { path: '/groups/:id(\\d+)/edit', component: GroupEdit},

  // ユーザー
    { path: '/users/new', component: UserNew},
    // { path: '/users/:id(\\d+)', component: Mypage},
    // { path: '/users/:id(\\d+)/edit', component: UserEdit},
    { 
      path: '/users/:id(\\d+)', 
      component: User, 
      props: true,
      children: [
        { path: "profile", component: UserProfile },
        { path: "application", component: Application },
        { path: "event", component: UserEvent },
        { path: "favorite", component: UserFavorite },
        { path: "edit", component: UserEdit },
      ]
    },

    { path: '/login', component: Login},
  // 申請関連
    // { path: '/users/:id(\\d+)/application', component: Application},
  // その他
    {
      path: '*', 
      redirect: '/'
    }
  ]
});