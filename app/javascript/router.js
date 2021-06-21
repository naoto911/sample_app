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
import Test from "./router/Group/Test";

import Mypage from "./router/User/Mypage";
import Login from "./router/User/Login";
import UserNew from "./router/User/UserNew";

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
        { path: "event", component: GroupEvent },
        { path: "member", component: GroupMember },
        { path: "edit", component: GroupEdit },
        { path: 'joins/:id(\\d+)', component: Test } //テスト
      ]
    },
  // ユーザー
    { path: '/users/new', component: UserNew},
    { path: '/users/:id(\\d+)', component: Mypage},
    { path: '/login', component: Login},
  // その他
    {
      path: '*', 
      redirect: '/'
    }
  ]
});