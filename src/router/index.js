/*
 * @Description:
 * @Date: 2023-08-28 15:07:48
 * @LastEditTime: 2023-12-12 09:19:09
 */
import { createRouter, createWebHashHistory } from "vue-router";
import component1 from "@/views/01_HelloPoint/HelloWorld.vue";

const routes = [
  {
    path: "/",
    children: [
      {
        path: "/1",
        component: component1,
        meta: {
          name: "绘制点",
        },
      }
    ],
    meta: {
      name: "WebGL入门",
    },
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
