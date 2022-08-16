<style scoped>
.align-right {
  text-align: right !important;
}

.align-center {
  text-align: center;
}

.go-bar-chart {
  width: 400px;
  height: 400px;
  background-color: white;
}
</style>

<template>
  <div class="w-full">
    <Splitter>
      <SplitterPanel>
        <Card>
          <template #title>
            <h4 class="m-2">{{ msg }}</h4>
          </template>
          <template #content>
            <DataTable
              :value="dataReferrers"
              removableSort
              v-model:filters="filters"
              responsiveLayout="scroll"
            >
              <ColumnGroup type="header">
                <Row>
                  <Column
                    field="referrer"
                    header="Referrer"
                    :colspan="1"
                    :rowspan="2"
                    :sortable="true"
                  />
                  <Column
                    :colspan="1"
                    class="align-center"
                    header="GC interne"
                  />
                  <Column
                    header="GC public"
                    :colspan="1"
                    class="align-center"
                  />
                </Row>
                <Row>
                  <Column
                    field="count_internal"
                    header="nombre"
                    :sortable="true"
                  />
                  <Column
                    field="count_public"
                    header="nombre"
                    :sortable="true"
                  />
                </Row>
              </ColumnGroup>
              <Column field="referrer" />
              <Column field="count_internal" class="align-right" />
              <Column field="count_public" class="align-right" />
            </DataTable>
          </template>
        </Card>
      </SplitterPanel>
      <SplitterPanel>
        <Card>
          <template #content>
            <div class="w-full">
              <Accordion :multiple="true" :activeIndex="[0,1]">
                <AccordionTab header="GC interne" >
                  <div ref="chartZone" class="go-bar-chart">
                    a nice chart will soon appear here ...
                  </div>
                </AccordionTab>
                <AccordionTab header="GC public">
                  <div ref="chartZonePublic" class="go-bar-chart">
                  a nice chart will soon appear here ...
                </div>
                </AccordionTab>
              </Accordion>
            </div>
          </template>
        </Card>
      </SplitterPanel>
    </Splitter>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import Splitter from "primevue/splitter";
import SplitterPanel from "primevue/splitterpanel";
import Card from "primevue/card";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import ColumnGroup from "primevue/columngroup";
import Row from "primevue/row";
import Accordion from "primevue/accordion";
import AccordionTab from "primevue/accordiontab";
import { FilterMatchMode } from "primevue/api";
import { fetchData } from "./fetchData";
import * as echarts from "echarts";
import {DEFAULT_BASE_SERVER_URL} from "../config"

const moduleName = "ListReferrers";
const urlRefererStats = `${DEFAULT_BASE_SERVER_URL}/data/referrers_stat.json`;
let myChart;
let myChartPublic;
const loadedData = ref(false);
const errorDataFetch = ref(null);
const dataReferrers = ref([
  {
    referrer: "aucune données n'est disponible en ce moment...",
    count_internal: 0,
    count_public: 0,
  },
]);
const filters = ref({
  referrer: { value: null, matchMode: FilterMatchMode.CONTAINS },
});
const chartZone = ref(null);
const chartZonePublic = ref(null);

onMounted(() => {
  const method = "onMounted";
  console.log(`##-->${moduleName}::${method}`);
  myChart = echarts.init(chartZone.value);
  myChartPublic = echarts.init(chartZonePublic.value);
  fetchData(urlRefererStats, dataReferrers, loadedData, errorDataFetch).then(
    () => {
      console.log(`##-->${moduleName}::${method} fetchData OK loadedData:${loadedData.value}`);
      const minCount = 100;
      const others = { name: "autres...", value: 0 };
      const arrGCInternal = dataReferrers.value
        .filter((v) => v.count_internal > 0)
        .map((v) => {
          if (v.count_internal > minCount) {
            return { name: v.referrer, value: v.count_internal };
          } else {
            others.value += v.count_internal;
          }
        });
      arrGCInternal.push(others);
      const chartOptionsGCInternal = {
        title: {
          text: "Referer of GC internal",
          left: "center",
        },
        tooltip: {
          trigger: "item",
        },
        legend: {
          orient: "vertical",
          left: "left",
          show: false,
        },
        series: [
          {
            name: "Access From",
            type: "pie",
            radius: "50%",
            data: arrGCInternal,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      };
      myChart.setOption(chartOptionsGCInternal);
      myChart.resize();

      const othersPublic = { name: "autres...", value: 0 };
      const arrGCPublic = dataReferrers.value
                                         .filter((v) => v.count_public > 0)
                                         .map((v) => {
                                           if (v.count_public > minCount) {
                                             return { name: v.referrer, value: v.count_public };
                                           } else {
                                             othersPublic.value += v.count_public;
                                           }
                                         });
      arrGCPublic.push(othersPublic);
      const chartOptionsGCPublic = {
        title: {
          text: "Referer of GC public",
          left: "center",
        },
        tooltip: {
          trigger: "item",
        },
        legend: {
          orient: "vertical",
          left: "left",
          show: false,
        },
        series: [
          {
            name: "Access From",
            type: "pie",
            radius: "50%",
            data: arrGCPublic,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      };
      myChartPublic.setOption(chartOptionsGCPublic);
      myChartPublic.resize();



      window.addEventListener("resize", myChart.resize);
    }
  );
});

defineProps({
  msg: {
    type: String,
    required: true,
  },
});
</script>
