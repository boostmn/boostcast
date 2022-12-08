<template>
    <div>
        <b-form-fieldset v-if="isBackendEnabled">
            <b-form-fieldset>
                <template #label>
                    <translate key="lang_hls">HTTP Live Streaming (HLS)</translate>
                </template>
                <template #description>
                    <translate key="lang_hls_desc">HTTP Live Streaming (HLS) is a new adaptive-bitrate technology supported by some clients. It does not use the standard broadcasting frontends.</translate>
                </template>

                <b-form-fieldset>
                    <b-form-row>
                        <b-wrapped-form-checkbox class="col-md-12" id="edit_form_enable_hls"
                                                 :field="form.enable_hls">
                            <template #label="{lang}">
                                <translate :key="lang">Enable HTTP Live Streaming (HLS)</translate>
                            </template>
                        </b-wrapped-form-checkbox>
                    </b-form-row>
                </b-form-fieldset>

                <b-form-fieldset v-if="form.enable_hls.$model">
                    <b-form-row>
                        <b-wrapped-form-checkbox class="col-md-12" id="edit_form_backend_hls_enable_on_public_player"
                                                 :field="form.backend_config.hls_enable_on_public_player">
                            <template #label="{lang}">
                                <translate :key="lang">Show HLS Stream on Public Player</translate>
                            </template>
                        </b-wrapped-form-checkbox>

                        <b-wrapped-form-checkbox class="col-md-12" id="edit_form_backend_hls_is_default"
                                                 :field="form.backend_config.hls_is_default">
                            <template #label="{lang}">
                                <translate :key="lang">Make HLS Stream Default in Public Player</translate>
                            </template>
                        </b-wrapped-form-checkbox>
                    </b-form-row>
                </b-form-fieldset>

                <b-form-fieldset v-if="showAdvanced && form.enable_hls.$model">
                    <b-form-row>
                        <b-wrapped-form-group class="col-md-4"
                                              id="edit_form_backend_hls_segment_length"
                                              :field="form.backend_config.hls_segment_length" input-type="number"
                                              :input-attrs="{ min: '0', max: '60' }" advanced>
                            <template #label="{lang}">
                                <translate :key="lang">Segment Length (Seconds)</translate>
                            </template>
                        </b-wrapped-form-group>

                        <b-wrapped-form-group class="col-md-4"
                                              id="edit_form_backend_hls_segments_in_playlist"
                                              :field="form.backend_config.hls_segments_in_playlist" input-type="number"
                                              :input-attrs="{ min: '0', max: '60' }" advanced>
                            <template #label="{lang}">
                                <translate :key="lang">Segments in Playlist</translate>
                            </template>
                        </b-wrapped-form-group>

                        <b-wrapped-form-group class="col-md-4"
                                              id="edit_form_backend_hls_segments_overhead"
                                              :field="form.backend_config.hls_segments_overhead" input-type="number"
                                              :input-attrs="{ min: '0', max: '60' }" advanced>
                            <template #label="{lang}">
                                <translate :key="lang">Segments Overhead</translate>
                            </template>
                        </b-wrapped-form-group>
                    </b-form-row>
                </b-form-fieldset>
            </b-form-fieldset>
        </b-form-fieldset>
        <backend-disabled v-else></backend-disabled>
    </div>
</template>

<script>
import BFormFieldset from "~/components/Form/BFormFieldset";
import BWrappedFormGroup from "~/components/Form/BWrappedFormGroup";
import {BACKEND_NONE} from "~/components/Entity/RadioAdapters";
import BWrappedFormCheckbox from "~/components/Form/BWrappedFormCheckbox";
import BFormMarkup from "~/components/Form/BFormMarkup";
import BackendDisabled from "./Common/BackendDisabled.vue";

export default {
    name: 'AdminStationsHlsForm',
    components: {BackendDisabled, BFormMarkup, BWrappedFormCheckbox, BWrappedFormGroup, BFormFieldset},
    props: {
        form: Object,
        station: Object,
        showAdvanced: {
            type: Boolean,
            default: true
        },
    },
    computed: {
        isBackendEnabled() {
            return this.form.backend_type.$model !== BACKEND_NONE;
        },
    }
}
</script>